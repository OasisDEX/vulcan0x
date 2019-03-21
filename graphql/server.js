import { express as config } from "../config/env";

const express = require("express");
const { postgraphile } = require("postgraphile");
const FilterPlugin = require("postgraphile-plugin-connection-filter");
const RateLimit = require("express-rate-limit");
const compression = require("compression");
const bodyParser = require("body-parser");
const fs = require('fs');
const _ = require('lodash');
const helmet = require('helmet');

const app = express();
app.use(compression());
app.use(bodyParser.json());
app.use(helmet());

// Rendering options for the index page
app.engine("html", require("ejs").renderFile);
app.set("views", "graphql/views");

// Display a page at the subdomain root
app.get("/", (req, res) => res.render("index.html"));

const graphqlConfig = {
  graphiql: true,
  graphqlRoute: "/v1",
  graphiqlRoute: "/v1/console",
  appendPlugins: [FilterPlugin],
  enableCors: true,
};

const schemas = ["api"];

const limiter = new RateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 30, // 30 requests per IP
  delayAfter: 10, // slow responses after 10 requests
  delayMs: 100, // by 1 second
});

const readEntities = (dir, ext) => {
  return _.fromPairs(fs.readdirSync(dir)
    .filter(file => file.endsWith(ext))
    .map(file => file.substr(0, file.length - ext.length))
    .map(file => [file, fs.readFileSync(`${dir}/${file}${ext}`, 'utf-8')]));
}

const allowedQueries = readEntities('graphql/queries', '.graphql');
console.log(`allowed queries: ${Object.keys(allowedQueries).join(', ')}`);
const devMode = process.env.GRAPHQL_DEV;
console.log(`dev mode: ${devMode ? 'enabled' : 'disabled'}`);

app.use(graphqlConfig.graphqlRoute, (req, resp, next) => {
  if (req.method !== "POST") {
    next();
    return;
  }
  const devModeRequest = (req.body.variables || {}).devMode;

  if (devModeRequest && devModeRequest !== devMode) {
    console.log("attempt to request dev mode");
  }

  if (!devMode || devModeRequest !== devMode) {
    if (allowedQueries.hasOwnProperty(req.body.operationName)) {
      req.body.query = allowedQueries[req.body.operationName];
    } else {
      console.log(`query not allowed: ${req.body.operationName}`);
      req.body.query = null;
    }
  } else {
    console.log("dev mode requested");
  }

  next();
});

app.use(postgraphile(config.db, schemas, graphqlConfig));

app.listen(config.port);
console.log(`Running a GraphQL API server at localhost:${config.port}`);
