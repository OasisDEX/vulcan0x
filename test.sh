#/bin/bash

# tests only graphql api with postgres integration
cd test/docker && docker-compose up --exit-code-from graphql_tester
TEST_RESULT=$?
docker-compose down
cd ../../
exit $TEST_RESULT
