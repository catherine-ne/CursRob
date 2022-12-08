$(document).ready(function() {

function fillGenerationResults() {
  if (!window.calculationResult) return;
  document.getElementById('expected-generation-result').style.visibility = 'visible';

  const {
    pdfMeanValue,
    pdfVarianceValue,
    pdfDeviationValue,
    neumannMethodExpectedValue,
    neumannMethodVariance,
    neumannMethodDeviation,
    metropolisMethodExpectedValue,
    metropolisMethodVariance,
    metropolisMethodDeviation,
    piecewiseMethodExpectedValue,
    piecewiseMethodVariance,
    piecewiseMethodDeviation,
  } = window.calculationResult;

  document.getElementById('analytic-mean-value').textContent = pdfMeanValue;
  document.getElementById('analytic-variance-value').textContent = pdfVarianceValue;
  document.getElementById('analytic-deviation-value').textContent = pdfDeviationValue;

  document.getElementById('neumann-mean-value').textContent = neumannMethodExpectedValue;
  document.getElementById('neumann-variance-value').textContent = neumannMethodVariance;
  document.getElementById('neumann-deviation-value').textContent = neumannMethodDeviation;

  document.getElementById('metropolis-mean-value').textContent = metropolisMethodExpectedValue;
  document.getElementById('metropolis-variance-value').textContent = metropolisMethodVariance;
  document.getElementById('metropolis-deviation-value').textContent = metropolisMethodDeviation;

  document.getElementById('piecewise-mean-value').textContent = piecewiseMethodExpectedValue;
  document.getElementById('piecewise-variance-value').textContent = piecewiseMethodVariance;
  document.getElementById('piecewise-deviation-value').textContent = piecewiseMethodDeviation;

}

fillGenerationResults();

});