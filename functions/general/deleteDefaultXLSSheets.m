function [] = deleteDefaultXLSSheets(fullfilename_xls)
    SHEETNAMES = {'Tabelle1', 'Tabelle2', 'Tabelle3', 'Sheet1', 'Sheet2', 'Sheet3'}; % for German and English MATLAB version
    % open excel file
    objExcel = actxserver('Excel.Application');
    try
        objExcel.Workbooks.Open(fullfilename_xls);
    catch
        warning('FAILED: Can not open Excel file.')
    end

    % delete default sheets
    for name = SHEETNAMES
        for i = 1:numel(SHEETNAMES)
            try
                objExcel.ActiveWorkbook.Worksheets.Item(SHEETNAMES{i}).Delete;
            catch
            end
        end
    end

    % Save and close Excel-file and clean up
    objExcel.ActiveWorkbook.Save;
    objExcel.ActiveWorkbook.Close;
    objExcel.Quit;
    objExcel.delete;
end