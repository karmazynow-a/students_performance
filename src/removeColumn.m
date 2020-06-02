
function mat_new = removeColumn(mat, column_idx)
    mat_new = zeros(size(mat, 1), size(mat, 2)-1);

    new_i = 1;
    for i = 1:size(mat, 2)
        if i ~= column_idx
           mat_new(:, new_i) =  mat(:, i);
           new_i = new_i + 1;
        end
    end
end