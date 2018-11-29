
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

    %  @brief Camera design display
    %
    %  This function allows to create an illustrative plot of the camera design
    %  considering the provided parameters.
    %
    %  @param sc_c Hyperbola linear eccentricity
    %  @param sc_e Hyperbola eccentricity
    %  @param sc_d Sensor radial size
    %  @param sc_output PNG output file path

    function camera_draw( sc_c, sc_e, sc_d, sc_output )

        % derivated parameters %
        sc_a = sc_c / sc_e;
        sc_b = sqrt( sc_c^2 - sc_a^2 );
        sc_p = ( sc_b^2 ) / sc_a;
        sc_t = atan( sc_p / ( 2 * sc_c ) );
        sc_h = 2 * sc_c * sc_d / sc_p;
        sc_w = sc_d / ( 2 * sc_c + sc_h );

        % assign figure font size %
        sc_fontsize = 12;

        % create figure %
        sc_figure = figure;

        % set figure configuration %
        hold on;
        grid on;
        box  on;

        % set figure font size %
        set( gca,'fontsize', sc_fontsize );

        % compute mirror surface parameter - angular %
        sc_mirror = [ -1 : 0.05 : +1 ] * acosh( sc_c / sc_a );

        % compute light ray parameter - angular %
        sc_ligray = [ -1 : 0.1 : +1 ] * acosh( sc_c / sc_a );

        % compute mirror surface %
        sc_mirsura_x = + sc_a * cosh( sc_mirror ) - sc_c;
        sc_mirsura_y = + sc_b * sinh( sc_mirror );
        sc_mirsurb_x = - sc_a * cosh( sc_mirror ) + sc_c;
        sc_mirsurb_y = + sc_b * sinh( sc_mirror );

        % compute position on mirror surface of light rays %
        sc_raymira_x = + sc_a * cosh( sc_ligray ) - sc_c;
        sc_raymira_y = + sc_b * sinh( sc_ligray );
        sc_raymira_n = sqrt( sc_raymira_x.^2 + sc_raymira_y.^2 );
        sc_raymirb_x = - sc_a * cosh( sc_ligray ) + sc_c;
        sc_raymirb_y = + sc_b * sinh( sc_ligray );
        sc_raymirb_n = sqrt( sc_raymira_x.^2 + sc_raymira_y.^2 );

        % display light rays %
        for i = 1 : length( sc_ligray )

            % check if light ray can be displayed - sensor blockage %
            if ( ( sc_raymira_x(i) == 0 ) || ( abs( sc_raymira_y(i) / sc_raymira_x(i) ) > sc_w ) )

                % display incoming ray %
                plot( [ sc_raymira_x(i), 2.0 * sc_p * ( sc_raymira_x(i) / sc_raymira_n(i) ) ], [ sc_raymira_y(i), 2.0 * sc_p * ( sc_raymira_y(i) / sc_raymira_n(i) ) ], '-', 'Color', [ 255 199 44 ] / 255, 'LineWidth', 1 );

                % display ray extension inside mirror %
                plot( [ 0, sc_raymira_x(i) ], [ 0, sc_raymira_y(i) ], '-', 'Color', [ 0.7 0.7 0.7 ], 'LineWidth', 1 );

                % compute ray angle %
                l = atan( sc_raymira_y(i) / ( 2 * sc_c + sc_raymira_x(i) ) );

                % compute ray position on sensor %
                s_x = -2 * sc_c - sc_h;
                s_y = -sc_h * tan( l );

                % display reflected ray %
                plot( [ sc_raymira_x(i), s_x ], [ sc_raymira_y(i), s_y ], '-', 'Color', [ 255 178 36 ] / 255, 'LineWidth', 1 );

            end

            % check if light ray can be displayed - sensor blockage %
            if ( ( sc_raymirb_x(i) == 0 ) || ( abs( sc_raymirb_y(i) /  sc_raymirb_x(i) ) > sc_w ) )

                % display incoming ray %
                plot( [ sc_raymirb_x(i), 2.0 * sc_p * ( sc_raymirb_x(i) / sc_raymirb_n(i) ) ], [ sc_raymirb_y(i), 2.0 * sc_p * ( sc_raymirb_y(i) / sc_raymirb_n(i) ) ], '-', 'Color', [ 255 199 44 ] / 255, 'LineWidth', 1 );

                % display ray extension inside mirror %
                plot( [ 0, sc_raymirb_x(i) ], [ 0, sc_raymirb_y(i) ], '-', 'Color', [ 0.7 0.7 0.7 ], 'LineWidth', 1 );

                % compute ray angle %
                l = atan( sc_raymirb_y(i) / ( 2 * sc_c - sc_raymirb_x(i)  ) );

                % compute ray position on sensor %
                s_x = +2 * sc_c + sc_h;
                s_y = -sc_h * tan( l );

                % display reflected ray %
                plot( [ sc_raymirb_x(i), s_x ], [ sc_raymirb_y(i), s_y ], '-', 'Color', [ 255 178 36 ] / 255, 'LineWidth', 1 );

            end

        end

        % display mirror surface %
        plot( sc_mirsura_x, sc_mirsura_y, '-', 'Color', [ 0.4 0.4 0.4 ], 'LineWidth', 2 );
        plot( sc_mirsurb_x, sc_mirsurb_y, '-', 'Color', [ 0.4 0.4 0.4 ], 'LineWidth', 2 );

        % display sensors representation %
        plot( [ 1, 1 ] * ( -2 * sc_c - sc_h ), [ sc_d, -sc_d ], '-', 'Color', [ 0.4 0.4 0.4 ], 'LineWidth', 4 );
        plot( [ 1, 1 ] * ( +2 * sc_c + sc_h ), [ sc_d, -sc_d ], '-', 'Color', [ 0.4 0.4 0.4 ], 'LineWidth', 4 );

        % display information on ccd %
        text( -sc_c - sc_c - sc_h, -sc_d * 1.25, 'L. CCD','fontsize', sc_fontsize, 'horizontalalignment', 'Left' );
        text( +sc_c + sc_c + sc_h, -sc_d * 1.25, 'R. CCD','fontsize', sc_fontsize, 'horizontalalignment', 'Right'  );

        % figure aspect ratio %
        daspect( [ 1 1 1 ] );

        % axis labels %
        xlabel( 'Optical axis [cm]' );
        ylabel( 'Cylindrical symetry [cm]' );

        % figure exportation %
        print( '-dpng', 'r600', sc_output );

    end

