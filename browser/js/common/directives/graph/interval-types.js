var intervalTypes = {
  daily: {
    setOldest: (date) => {
      date.setHours(date.getHours() - 4);
      date.setDate(date.getDate() - 1);
    },
    groupBy: 'batch_time',
    denominator: 5
  },
  weekly: {
    setOldest: (date) => {
      date.setDate(date.getDate() - 8);
    },
    groupBy: 'batch_time_30',
    denominator: 30
  },
  monthly: {
    setOldest: (date) => {
      date.setDate(date.getDate() - 34);
    },
    groupBy: 'batch_time_120',
    denominator: 120
  },
  yearly: {
    setOldest: (date) => {
      date.setDate(date.getDate() - 395);
    },
    groupBy: 'batch_time_24h',
    denominator: 1440
  },
};
