function [] = saveResultsAsXLSX(object_stats_export, overall_stats_export, counting_stats_export, fullfilename_xlsx)
    
    % convert to table
    object_stats_table = struct2table(object_stats_export);
    overall_stats_table = struct2table(overall_stats_export);
    counting_stats_table = struct2table(counting_stats_export);
    
    % save as .xlsx    
    warning('off', 'MATLAB:DELETE:Permission') % supress warnings
    if exist(fullfilename_xlsx) ~= 0 % 2 = is file
        recycle('on');
        delete(fullfilename_xlsx);
    end
    
    warning( 'off', 'MATLAB:xlswrite:AddSheet' ); % ignore excel warning, that specific sheet was added
    writetable(object_stats_table, fullfilename_xlsx, 'Sheet', 'object_stats');
    writetable(overall_stats_table, fullfilename_xlsx, 'Sheet', 'overall_stats');
    writetable(counting_stats_table, fullfilename_xlsx, 'Sheet', 'counting_stats');
    
    deleteDefaultXLSSheets(fullfilename_xlsx);
    warning('on', 'MATLAB:DELETE:Permission')
    
end

