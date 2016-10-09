function vec = remove_peak(vec, peak, value, medwin)
  
  peak_value = vec(peak);
  threshold = median(vec(peak-medwin:peak+medwin));

  old_value = peak_value;
  i = peak;
  while (1) 

    % Move right
    i = i + 1;
    if (i > length(vec))
      i = 1;
    end
    
    % End if threshold
    if (vec(i) <= threshold)
      break;
    end

    vec(i) = value;
  end
  
  i = peak;
  while (1) 

    % Move left
    i = i - 1;
    if (i == 0)
      i = length(vec);
    end
    
    % End if uphill
    if (vec(i) <= threshold)
      break;
    end

    vec(i) = value;
  end
  vec(peak) = value;
