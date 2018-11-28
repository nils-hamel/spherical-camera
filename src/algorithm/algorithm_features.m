
    function sc_point = algorithm_features( sc_r, sc_d )

        % compute point position %
        sc_point(:,1) = sc_r(:) .* sc_d(:,1);
        sc_point(:,2) = sc_r(:) .* sc_d(:,2);
        sc_point(:,3) = sc_r(:) .* sc_d(:,3);

    end
