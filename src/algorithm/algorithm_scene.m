
    function sc_scene = algorithm_scene( sc_center, sc_radius, sc_number )

        % memory management %
        sc_param = zeros( sc_number, 4 );

        % scene precursor %
        sc_param(:,1) = rand( sc_number, 1 );

        % scene precursor %
        sc_param(:,2) = randn( sc_number, 1 );
        sc_param(:,3) = randn( sc_number, 1 );
        sc_param(:,4) = randn( sc_number, 1 );

        % compute distribution factor %
        sc_norm = ( sc_radius * sc_param(:,1) .^ ( 1./3. ) ) ./ sqrt( sc_param(:,2) .* sc_param(:,2) + sc_param(:,3) .* sc_param(:,3) + sc_param(:,4) .* sc_param(:,4) );

        % memory management %
        sc_scene = zeros( sc_number, 3 );

        % compute scene points %
        sc_scene(:,1) = sc_norm .* sc_param(:,2);
        sc_scene(:,2) = sc_norm .* sc_param(:,3);
        sc_scene(:,3) = sc_norm .* sc_param(:,4);

    end
