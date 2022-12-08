$(document).ready(function() {

function initExport() {
  if (!window.calculationResult) return;

  const FILENAME_PREFIX = 'LogNormalDistributionDataExport';

  const initExportXlsx = () => {
    const xlsxExportButton = document.getElementById('export-as-xlsx');
    xlsxExportButton.addEventListener('click', () => {
      const optionsInfo = [
        ["Sample size",  window.calculationResult.options.sampleSize],
        ["Right boundary",    window.calculationResult.options.max_x],
        ["Step",        window.calculationResult.options.step],
        ["alpha",         window.calculationResult.options.alpha],
        ["Mu",          window.calculationResult.options.beta],
        [''],
      ];

      const exportValuesInfo = [
        ['Mean (analytic)',   window.calculationResult.pdfMeanValue],
        ['Variance (analytic)', window.calculationResult.pdfVarianceValue],
        [''],
        ['Mean (Neumann)',    window.calculationResult.neumannMethodExpectedValue],
        ['Variance (Neumann)',  window.calculationResult.neumannMethodVariance],
        ['Deviation (Neumann)', window.calculationResult.neumannMethodDeviation],
        [''],
        ['Mean (Metropolis)',     window.calculationResult.metropolisMethodExpectedValue],
        ['Variance (Metropolis)',   window.calculationResult.metropolisMethodVariance],
        ['Deviation (Metropolis)',  window.calculationResult.metropolisMethodDeviation],
        [''],
        ['Mean (Piecewise Approximation)',    window.calculationResult.piecewiseMethodExpectedValue],
        ['Variance (Piecewise Approximation)',  window.calculationResult.piecewiseMethodVariance],
        ['Deviation (Piecewise Approximation)', window.calculationResult.piecewiseMethodDeviation],
        [''],
      ];

      const calculationResultByMethods = [
        ['Neumann method frequencies',    ...window.calculationResult.neumannMethod],
        ['Metropolis method frequencies',   ...window.calculationResult.metropolisMethod],
        ['Piecewise method frequencies',  ...window.calculationResult.piecewiseApproximationMethod],
      ];

      const xlsxArrayData = [
        ...optionsInfo,
        ...exportValuesInfo,
        ...calculationResultByMethods,
      ];

      const SHEET_NAME = 'LogNormalDistributionData';
      const XLSX = window.XLSX;
      const wb = XLSX.utils.book_new();
      wb.SheetNames.push(SHEET_NAME);
      wb.Sheets[SHEET_NAME] = XLSX.utils.aoa_to_sheet(xlsxArrayData);
      XLSX.writeFile(wb, `${FILENAME_PREFIX}.xlsx`);
    });
  };

  initExportXlsx();
}

initExport();

});