
    %  spherical-camera
    %
    %      Nils Hamel - nils.hamel@bluewin.ch
    %      Copyright (c) 2016-2018 DHLAB, EPFL
    %
    %  This program is free software: you can redistribute it and/or modify
    %  it under the terms of the GNU General Public License as published by
    %  the Free Software Foundation, either version 3 of the License, or
    %  (at your option) any later version.
    %
    %  This program is distributed in the hope that it will be useful,
    %  but WITHOUT ANY WARRANTY; without even the implied warranty of
    %  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %  GNU General Public License for more details.
    %
    %  You should have received a copy of the GNU General Public License
    %  along with this program.  If not, see <http://www.gnu.org/licenses/>.

    function algorithm_plot_scene( sc_da, sc_ra, sc_db, sc_rb, sc_r, sc_t, sc_output )

        % transform direction %
        sc_da = algorithm_rotate( sc_da, sc_r );

        % compute last iteration features %
        sc_fa = algorithm_features( sc_ra, sc_da );

        % tranform center %
        sc_fa(:,1) = sc_fa(:,1) + sc_t(1);
        sc_fa(:,2) = sc_fa(:,2) + sc_t(2);
        sc_fa(:,3) = sc_fa(:,3) + sc_t(3);

        % compute last iteration features %
        sc_fb = algorithm_features( sc_rb, sc_db );

        % create figure %
        figure;

        % figrue configuration %
        hold on;
        grid on;
        box  on;

        % display points %
        plot3( sc_fb(:,1), sc_fb(:,2), sc_fb(:,3), 'o', 'color', [ 255 178 36 ] / 255 );

        % display points %
        plot3( sc_fa(:,1), sc_fa(:,2), sc_fa(:,3), 'x', 'color', [ 255 178 36 ] / 255 );

        % parsing features %
        for sc_i = 1 : size( sc_da, 1 )

            % display direction %
            plot3( [ 0, sc_fb(sc_i,1) ], [ 0, sc_fb(sc_i,2) ], [ 0, sc_fb(sc_i,3) ], '-', 'color', [ 0.7, 0.7, 0.7 ], 'linewidth', 1 );

            % display direction %
            plot3( [ sc_t(1), sc_fa(sc_i,1) ], [ sc_t(2), sc_fa(sc_i,2) ], [ sc_t(3), sc_fa(sc_i,3) ], '-', 'color', [ 0.7, 0.7, 0.7 ], 'linewidth', 1 );

        end

        % display epipolar line %
        plot3( [ 0, sc_t(1) ], [ 0, sc_t(2) ], [ 0, sc_t(3) ], '-', 'color', [ 36 131 255 ] / 255, 'linewidth', 2 );

        % display camera center %
        plot3( 0, 0, 0, 'o', 'color', [ 36 131 255 ] / 255 );

        % display camera center %
        plot3( sc_t(1), sc_t(2), sc_t(3), 'x', 'color', [ 36 131 255 ] / 255 );

        % axis configuration %
        xlabel( 'x' );
        ylabel( 'y' );
        zlabel( 'z' );

        axis( 'equal' );

        % ratio configuration %
        daspect( [ 1 1 1 ] );

        % view configuration %
        view( [ 70 20 ] );

        % export %
        print( '-dpng', '-r300', sc_output );

    end
