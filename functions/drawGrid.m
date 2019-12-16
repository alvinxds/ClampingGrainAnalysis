function img_grid = drawGrid(img)

    img_grid = img;
    n_grids = 25;
    
    dx = floor(size(img, 2)./n_grids);
    dy = dx;
    
    n_lines = 2;
    
    for i = 0:(n_lines-1)
        % Change every dx'th row to white
        img_grid((dx+i):dx:end,:,:) = 255;
        % Change every dy'th column to white
        img_grid(:,(dy+i):dy:end,:) = 255;   
    end
    % add index
    
    for i = 1:n_grids
        for j = 1:n_grids
            text = ['(', num2str(i), ', ', num2str(j), ')'];
            position_x = (i - 0.5).*dx;
            position_y = (j - 0.5).*dy;            
            img_grid = insertText(img_grid, [position_x, position_y], text, 'AnchorPoint', 'center', 'TextColor', 'white', 'FontSize', 12, 'BoxOpacity', 0.5, 'BoxColor', 'black');           
            
        end
        
    end

end

