function evaluate(filename, exp_name, result_snr, x, xhat)
    data_in = [min(x), median(x), mean(x), max(x), std(x)];
    data_out = [min(xhat), median(xhat), mean(xhat), max(xhat), std(xhat)];
    change = data_out-data_in;

    fid = fopen(filename, 'a');
    
    if result_snr > -2.44
        result = 'Win';
    else
        result = 'Lose';
    end
    
    % Check if the file was successfully opened
    if fid == -1
        error('Error opening file %s for appending', filename);
    end
    
    fprintf(fid, '\n\n%s', exp_name);
    fprintf(fid, '\n%.2f,%.2f,%.2f,%.2f,%.2f', data_in);
    fprintf(fid, '\n%.2f,%.2f,%.2f,%.2f,%.2f', data_out);
    fprintf(fid, '\n%.2f,%.2f,%.2f,%.2f,%.2f', change);
    fprintf(fid, '\n%s', result);
    
    % Close and save to file
    fclose(fid);
end