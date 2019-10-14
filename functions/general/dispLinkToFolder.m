function dispLinkToFolder( folder, pre_text, link_text, post_text )
%display Link to folder in command line
%this method is from [Paul Macey, July 2008]

    if ~ispc, return, end

    if nargin < 1
        folder = uigetdir('Select folder to make link for');
        if folder == 0, return, end
    end
    if ~exist(folder,'dir') && ~exist(folder,'file')
        disp(['Folder "',folder,'" does not exist.'])
        return
    end
    if nargin < 2
        pre_text = '';
    end
    if nargin < 3
        link_text = folder;
    end
    if nargin < 4
        post_text = '';
    end

    % Notes:  
    %        * " &" returns control to the matlab command window
    %        * don't need "" for folder names with spaces 
    disp([pre_text,...
        '<a href = "matlab: [s,r] = system(''explorer ',folder,' &'');">',...
        link_text,'</a>',...
        post_text])
end