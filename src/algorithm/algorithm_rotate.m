
    function sc_rotate = algorithm_rotate( sc_point, sc_r )

        % initialise memory %
        sc_rotate = zeros( size( sc_point ) );

        % parsing points %
        for sc_i = 1 : size( sc_point, 1 )

            % apply rotation %
            sc_rotate(sc_i,:) = sc_r * sc_point(sc_i,:)';

        end

    end
