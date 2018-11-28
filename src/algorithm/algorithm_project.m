
    function sc_direction = algorithm_project( sc_center, sc_rotation, sc_scene )

        % memory management %
        sc_direction = zeros( size( sc_scene ) );

        % parsing scene %
        for sc_i = 1 : size( sc_scene, 1 )

            % frame transformation %
            sc_direction(sc_i,:) = sc_scene(sc_i,:) - sc_center;

            % projection on unit sphere %
            sc_direction(sc_i,:) = sc_direction(sc_i,:) / norm( sc_direction(sc_i,:) );

            % apply camera rotation %
            sc_direction(sc_i,:) = ( sc_rotation * sc_direction(sc_i,:)' )';

        end

    end
