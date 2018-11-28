
    function [ sc_ra, sc_rb ] = algorithm_radius( sc_ca, sc_da, sc_cb, sc_db )

        % initialise memory %
        sc_ra = zeros( size( sc_da, 1 ), 1 );
        sc_rb = zeros( size( sc_db, 1 ), 1 );

        % parsing radius %
        for sc_i = 1 : size( sc_da, 1 )

            % compute radius correction %
            [ sc_ra(sc_i), sc_rb(sc_i) ] = algorithm_intersect_2( sc_ca, sc_da(sc_i,:), sc_cb, sc_db(sc_i,:) );

        end

    end
