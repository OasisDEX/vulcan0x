import { express as config } from "../config/env";

const express = require("express");
const { postgraphile } = require("postgraphile");
const FilterPlugin = require("postgraphile-plugin-connection-filter");
const RateLimit = require("express-rate-limit");
const compression = require("compression");

const app = express();
app.use(compression());

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

app.use(postgraphile(config.db, schemas, graphqlConfig));

app.listen(config.port);
console.log(`Running a GraphQL API server at localhost:${config.port}`);
