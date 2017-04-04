ROWS = 30;  
COLS = 30;

gridCell = uint16(zeros(ROWS, COLS));

gridCell(1, 1:end) = intmax('uint16');
gridCell(end, 1:end) = intmax('uint16');
gridCell(1:end, 1) = intmax('uint16');
gridCell(1:end, end) = intmax('uint16');

gridRow = [];
grid = [];

for j = 1:17
   
        gridRow = [gridRow gridCell];
end

for j = 1:17
   
        grid = [grid; gridRow];
end

imshow(grid);