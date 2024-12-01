const express = require("express");
const router = express.Router();
const app = express();
const request = require("request");
const healthCheckUrl =
  "https://www.stadtwerke-le.de/tools/voting/voting/UAEuMKIe59If";

const Prometheus = require("prom-client");

app.get("/", async (req, res) => {
  res.end(await Prometheus.register.metrics());
});

const votesPercentage = new Prometheus.Gauge({
  name: "votes_percent",
  help: "votes in percent",
  labelNames: ["title"],
});
const votesCount = new Prometheus.Gauge({
  name: "votes_count",
  help: "votes counted",
  labelNames: ["title"],
});

function updateMetrics() {
  request(
    {
      url: healthCheckUrl,
      method: "GET",
    },
    function (error, response, body) {
      if (!error && response.statusCode === 200) {
        const json = JSON.parse(body);

        for (const entry of json.result) {
          votesPercentage.set({ title: entry.title }, entry.percent);
          votesCount.set({ title: entry.title }, entry.count);
        }
      } else {
        console.error(error);
      }
    },
  );
}

setInterval(() => {
  updateMetrics();
}, 10000);

updateMetrics();
app.listen(process.env.PORT || 3000);
