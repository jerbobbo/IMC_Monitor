var graphTypes =
  {
    ASR: {
      name: "ASR",
      areaAbbr: "ASR",
      lineAbbr: "ASRm",
      yAxis: "%",
      areaFunc: d => 100*d.completed/d.originSeiz || 0,
      lineFunc: d => 100*d.completed/d.originAsrmSeiz || 0,
      maxGraphHeight: data => d3.max(data, d => 100*d.completed/d.originAsrmSeiz || 0),
      avgAreaFunc: data => roundToFixed( d3.mean(data, d => 100*d.completed/d.originSeiz || 0) ),
      avgLineFunc: data => roundToFixed( d3.mean(data, d => 100*d.completed/d.originAsrmSeiz || 0) ),
      currAreaFunc: data => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading.completed/lastFullReading.originSeiz || 0 );
      },
      currLineFunc: data => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading.completed/lastFullReading.originAsrmSeiz || 0 );
      }
    },
    ACD: {
      name: "ACD",
      areaAbbr: "ACD",
      yAxis: "Minutes",
      areaFunc: d => d.connMinutes/d.completed || 0,
      lineFunc: d => d.connMinutes/d.completed  || 0,
      maxGraphHeight: data => d3.max(data, d => d.connMinutes/d.completed || 0),
      avgAreaFunc: data => roundToFixed( d3.mean(data, d => d.connMinutes/d.completed || 0) ),
      currAreaFunc: function(data) {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( lastFullReading.connMinutes/lastFullReading.completed || 0 );
      }
    },
    AnswerDelay: {
      name: "Answer Delay",
      areaAbbr: "Answer Delay",
      yAxis: "Seconds",
      areaFunc: d => d.originAnsDel/d.originSeiz || 0,
      lineFunc: d => d.originAnsDel/d.originSeiz  || 0,
      maxGraphHeight: data => d3.max(data, d => d.originAnsDel/d.originSeiz || 0),
      avgAreaFunc: data => roundToFixed( d3.mean(data, d => d.originAnsDel/d.originSeiz || 0) ),
      currAreaFunc: function(data) {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( lastFullReading.originAnsDel/lastFullReading.originSeiz || 0 );
      }
    },
    Seizures: {
      name: "Seiz/Min",
      areaAbbr: "Completed/Min",
      lineAbbr: "Seiz/Min",
      yAxis: "Seiz/Min",
      lineFunc: (d, denom) => d.originSeiz/denom || 0,
      areaFunc: (d, denom) => d.completed/denom  || 0,
      maxGraphHeight: (data, denom) => d3.max(data, d => d.originSeiz/denom || 0),
      avgAreaFunc: (data, denom) => roundToFixed( d3.mean(data, d => d.completed/denom  || 0) ),
      avgLineFunc: (data, denom) => roundToFixed( d3.mean(data, d => d.originSeiz/denom  || 0) ),
      currAreaFunc: function(data, denom) {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( lastFullReading.completed/denom || 0 );
      },
      currLineFunc: function(data, denom) {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( lastFullReading.originSeiz/denom || 0 );
      }
    },
    NoCircuit: {
      name: "No Circuit",
      areaAbbr: "No Circuit",
      yAxis: "%",
      lineFunc: d => 100*d.originNoCirc/d.originSeiz || 0,
      areaFunc: d => 100*d.originNoCirc/d.originSeiz || 0,
      maxGraphHeight: data => d3.max(data, d => 100*d.originNoCirc/d.originSeiz || 0),
      avgAreaFunc: data => roundToFixed( d3.mean(data, d => 100*d.originNoCirc/d.originSeiz || 0) ),
      currAreaFunc: function(data) {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading.originNoCirc/lastFullReading.originSeiz || 0 );
      }
    },
    Normal: {
      name: "Normal Disc",
      areaAbbr: "Normal Disc",
      yAxis: "%",
      lineFunc: d => 100*d.originNormalDisc/d.originSeiz || 0,
      areaFunc: d => 100*d.originNormalDisc/d.originSeiz || 0,
      maxGraphHeight: data => d3.max(data, d => 100*d.originNormalDisc/d.originSeiz || 0),
      avgAreaFunc: data => roundToFixed( d3.mean(data, d => 100*d.originNormalDisc/d.originSeiz || 0) ),
      currAreaFunc: function(data) {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading.originNormalDisc/lastFullReading.originSeiz || 0 );
      }
    },
    Failure: {
      name: "Failure Disc",
      areaAbbr: "Failure Disc",
      yAxis: "%",
      lineFunc: d => 100*d.originFailDisc/d.originSeiz || 0,
      areaFunc: d => 100*d.originFailDisc/d.originSeiz || 0,
      maxGraphHeight: data => d3.max(data, d => 100*d.originFailDisc/d.originSeiz || 0),
      avgAreaFunc: data => roundToFixed( d3.mean(data, d => 100*d.originFailDisc/d.originSeiz || 0) ),
      currAreaFunc: function(data) {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading.originFailDisc/lastFullReading.originSeiz || 0 );
      }
    }
  };

  function roundToFixed(num, digits=1) {
    return parseFloat(Math.round(num * 100) / 100).toFixed(digits);
  }
