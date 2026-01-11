function nmse_db = compute_nmse(y_true, y_pred)
    nmse_val = sum(abs(y_true - y_pred).^2) / sum(abs(y_true).^2);
    nmse_db = 10 * log10(nmse_val);
end
