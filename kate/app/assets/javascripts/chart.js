$(document).ready( function () {
  function initializeChart() {
    if (!window.calculationResult) return;
    const xMaximumValue = window.calculationResult.options.max_x;
    const stepValue = window.calculationResult.options.step;

    const chartElement = document.getElementById('distribution-histogram-chart');
    const chartLabels = Array.from(Array(xMaximumValue / stepValue).keys()).map((_, index) => (index * stepValue).toFixed(1));

    new Chart(chartElement, {
      type: 'bar',
      data: {
        labels: chartLabels,
        datasets: [
          {
            label: "Neumann",
            data: window.calculationResult.neumannMethod,
            backgroundColor: "green",
          },
          {
            label: "Metropolis",
            data: window.calculationResult.metropolisMethod,
            backgroundColor: "blue",
          },
          {
            label: "Piecewise Approximation",
            data: window.calculationResult.piecewiseApproximationMethod,
            backgroundColor: "red",
          }
        ]
      },
      options: {
        scales: {
          y: {
            title: {
              display: true,
              text: "Frequency",
            },
            beginAtZero: true
          },
          x: {
            title: {
              display: true,
              text: 'Interval value'
            }
          }
        }
      }
    });
  }

  initializeChart();
})