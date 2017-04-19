var graphTypes =
  {
    ASR: {
      name: "ASR",
      areaAbbr: "ASR",
      lineAbbr: "ASRm",
      yAxis: "%",
      areaFunc: (d, originTerm) => 100*d.completed/d[`${originTerm}Seiz`] || 0,
      lineFunc: (d, originTerm) => 100*d.completed/d[`${originTerm}AsrmSeiz`] || 0,
      maxGraphHeight: (data, originTerm) => d3.max(data, d => 100*d.completed/d[`${originTerm}AsrmSeiz`] || 0),
      avgAreaFunc: (data, originTerm) => roundToFixed( d3.mean(data, d => 100*d.completed/d[`${originTerm}Seiz`] || 0) ),
      avgLineFunc: (data, originTerm) => roundToFixed( d3.mean(data, d => 100*d.completed/d[`${originTerm}AsrmSeiz`] || 0) ),
      currAreaFunc: (data, originTerm) => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading.completed/lastFullReading[`${originTerm}Seiz`] || 0 );
      },
      currLineFunc: (data, originTerm) => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading.completed/lastFullReading[`${originTerm}AsrmSeiz`] || 0 );
      }
    },
    ACD: {
      name: "ACD",
      areaAbbr: "ACD",
      yAxis: "Minutes",
      areaFunc: (d, originTerm) => d.connMinutes/d.completed || 0,
      lineFunc: (d, originTerm) => d.connMinutes/d.completed  || 0,
      maxGraphHeight: (data, originTerm) => d3.max(data, d => d.connMinutes/d.completed || 0),
      avgAreaFunc: (data, originTerm) => roundToFixed( d3.mean(data, d => d.connMinutes/d.completed || 0) ),
      currAreaFunc: data => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( lastFullReading.connMinutes/lastFullReading.completed || 0 );
      }
    },
    AnsDel: {
      name: "Answer Delay",
      areaAbbr: "Answer Delay",
      yAxis: "Seconds",
      areaFunc: (d, originTerm) => d[`${originTerm}AnsDel`]/d[`${originTerm}Seiz`] || 0,
      lineFunc: (d, originTerm) => d[`${originTerm}AnsDel`]/d[`${originTerm}Seiz`]  || 0,
      maxGraphHeight: (data, originTerm) => d3.max(data, d => d[`${originTerm}AnsDel`]/d[`${originTerm}Seiz`] || 0),
      avgAreaFunc: (data, originTerm) => roundToFixed( d3.mean(data, d => d[`${originTerm}AnsDel`]/d[`${originTerm}Seiz`] || 0) ),
      currAreaFunc: (data, originTerm) => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( lastFullReading[`${originTerm}AnsDel`]/lastFullReading[`${originTerm}Seiz`] || 0 );
      }
    },
    Seizures: {
      name: "Seiz/Min",
      areaAbbr: "Completed/Min",
      lineAbbr: "Seiz/Min",
      yAxis: "Seiz/Min",
      lineFunc: (d, originTerm, denom) => d[`${originTerm}Seiz`]/denom || 0,
      areaFunc: (d, originTerm, denom) => d.completed/denom  || 0,
      maxGraphHeight: (data, originTerm, denom) => d3.max(data, d => d[`${originTerm}Seiz`]/denom || 0),
      avgAreaFunc: (data, originTerm, denom) => roundToFixed( d3.mean(data, d => d.completed/denom  || 0) ),
      avgLineFunc: (data, originTerm, denom) => roundToFixed( d3.mean(data, d => d[`${originTerm}Seiz`]/denom  || 0) ),
      currAreaFunc: (data, originTerm, denom) => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( lastFullReading.completed/denom || 0 );
      },
      currLineFunc: (data, originTerm, denom) => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( lastFullReading[`${originTerm}Seiz`]/denom || 0 );
      }
    },
    NoCirc: {
      name: "No Circuit",
      areaAbbr: "No Circuit",
      yAxis: "%",
      lineFunc: (d, originTerm) => 100*d[`${originTerm}NoCirc`]/d[`${originTerm}Seiz`] || 0,
      areaFunc: (d, originTerm) => 100*d[`${originTerm}NoCirc`]/d[`${originTerm}Seiz`] || 0,
      maxGraphHeight: (data, originTerm) => d3.max(data, d => 100*d[`${originTerm}NoCirc`]/d[`${originTerm}Seiz`] || 0),
      avgAreaFunc: (data, originTerm) => roundToFixed( d3.mean(data, d => 100*d[`${originTerm}NoCirc`]/d[`${originTerm}Seiz`] || 0) ),
      currAreaFunc: (data, originTerm) => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading[`${originTerm}NoCirc`]/lastFullReading[`${originTerm}Seiz`] || 0 );
      }
    },
    Normal: {
      name: "Normal Disc",
      areaAbbr: "Normal Disc",
      yAxis: "%",
      lineFunc: (d, originTerm) => 100*d[`${originTerm}NormalDisc`]/d[`${originTerm}Seiz`] || 0,
      areaFunc: (d, originTerm) => 100*d[`${originTerm}NormalDisc`]/d[`${originTerm}Seiz`] || 0,
      maxGraphHeight: (data, originTerm) => d3.max(data, d => 100*d[`${originTerm}NormalDisc`]/d[`${originTerm}Seiz`] || 0),
      avgAreaFunc: (data, originTerm) => roundToFixed( d3.mean(data, d => 100*d[`${originTerm}NormalDisc`]/d[`${originTerm}Seiz`] || 0) ),
      currAreaFunc: (data, originTerm) => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading[`${originTerm}NormalDisc`]/lastFullReading[`${originTerm}Seiz`] || 0 );
      }
    },
    Failure: {
      name: "Failure Disc",
      areaAbbr: "Failure Disc",
      yAxis: "%",
      lineFunc: (d, originTerm) => 100*d[`${originTerm}FailDisc`]/d[`${originTerm}Seiz`] || 0,
      areaFunc: (d, originTerm) => 100*d[`${originTerm}FailDisc`]/d[`${originTerm}Seiz`] || 0,
      maxGraphHeight: (data, originTerm) => d3.max(data, d => 100*d[`${originTerm}FailDisc`]/d[`${originTerm}Seiz`] || 0),
      avgAreaFunc: (data, originTerm) => roundToFixed( d3.mean(data, d => 100*d[`${originTerm}FailDisc`]/d[`${originTerm}Seiz`] || 0) ),
      currAreaFunc: (data, originTerm) => {
        var lastFullReading = data[ data.length-2 ];
        return roundToFixed( 100*lastFullReading[`${originTerm}FailDisc`]/lastFullReading[`${originTerm}Seiz`] || 0 );
      }
    }
  };

  function roundToFixed(num, digits=1) {
    return parseFloat(Math.round(num * 100) / 100).toFixed(digits);
  }
