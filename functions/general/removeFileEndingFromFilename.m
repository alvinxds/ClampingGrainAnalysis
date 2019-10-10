function [shorten_filename] = removeFileEndingFromFilename(filename)
    if isstring(filename)
        filename = convertStringsToChars(filename);
    end
    
    n_digits = length(filename);
    
    shorten_filename = '';
    for i = 1:n_digits
        digit = filename(i);
       if  digit ~= '.'
           shorten_filename(i) = digit;
       else
           break
       end  
    end

end

