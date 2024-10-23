function convertSeverity(s) {
  switch (s.toLowerCase()) {
    case "error":
      return "ERROR";
    case "warning":
      return "WARNING";
    default:
      return "INFO";
  }
}

function processMarkuplintResults(results) {
  return results.map((result) => ({
    message: result.message,
    location: {
      path: result.filePath,
      range: {
        start: {
          line: result.line,
          column: result.col,
        },
      },
    },
    severity: convertSeverity(result.severity),
    code: {
      value: result.ruleId,
      url: `https://markuplint.dev/rules/${result.ruleId}`,
    },
    original_output: JSON.stringify(result),
  }));
}

let input = "";
process.stdin.resume();
process.stdin.setEncoding("utf8");

process.stdin.on("data", function (chunk) {
  input += chunk;
});

process.stdin.on("end", function () {
  const markuplintResults = JSON.parse(input);
  const rdjsonResults = {
    source: {
      name: "markuplint",
      url: "https://markuplint.dev/",
    },
    diagnostics: processMarkuplintResults(markuplintResults),
  };
  console.log(JSON.stringify(rdjsonResults, null, 2));
});
