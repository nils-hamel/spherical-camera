
    function sc_error = algorithm_error( sc_ca, sc_da, sc_ra, sc_cb, sc_db, sc_rb )

        % compute point set %
        sc_pa = sc_ca + algorithm_features( sc_ra, sc_da );

        % compute point set %
        sc_pb = sc_cb + algorithm_features( sc_rb, sc_db );

        % error extremum %
        sc_error = 0.0;

        % parsing features %
        for sc_i = 1 : size( sc_da, 1 )

            % compute feature error %
            sc_local = norm( sc_pa(sc_i,:) - sc_pb(sc_i,:) );

            % detect extremum %
            if ( sc_local > sc_error )

                % update extremum %
                sc_error = sc_local;

            end

        end

    end
