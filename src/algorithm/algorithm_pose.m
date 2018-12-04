
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

    function [ sc_r, sc_t, sc_ra, sc_rb, sc_da, sc_db, sc_err_rad, sc_err_r, sc_err_t ] = algorithm_pose( sc_da, sc_db, sc_tol )

        % initialise radii %
        sc_ra = ones( size( sc_da, 1 ), 1 );
        sc_rb = ones( size( sc_db, 1 ), 1 );

        % iteration control %
        sc_flag = true;

        % iteration condition %
        sc_icc = +0.0;
        sc_icp = -1.0;

        % iteration counter %
        sc_iter = 1;

        % pose estimation %
        while ( sc_flag == true )

            % compute camera features %
            sc_fa = algorithm_features( sc_ra, sc_da );

            % compute camera features %
            sc_fb = algorithm_features( sc_rb, sc_db );

            % compute registration transformation %
            [ sc_rr, sc_rt ] = algorithm_register( sc_fa, sc_fb );

            % rotate first point set on second camera frame %
            sc_dc = algorithm_rotate( sc_da, sc_rr );

            % compute radius correction %
            [ sc_ra, sc_rb ] = algorithm_radius( sc_rt', sc_dc, zeros( 1, 3 ), sc_db );

            % compute error %
            sc_icc = algorithm_error( sc_rt', sc_dc, sc_ra, zeros( 1, 3 ), sc_db, sc_rb ) / norm( sc_rt );

            % compute iteration condition %
            if ( abs( sc_icc - sc_icp ) < sc_tol )

                % update iteration control %
                sc_flag = false;

            else

                % push previous error %
                sc_icp = sc_icc;

            end

            % filtering process - stability %
            [ sc_ra, sc_rb, sc_da, sc_db ] = algorithm_filter( sc_ra, sc_da, sc_rb, sc_db, 3.0 );

            % display information %
            fprintf( 2, 'Iteration %i with %g remaining and %d features\n', sc_iter, sc_icc, size( sc_ra, 1 ) );

            % index error on radius %
            sc_err_rad( sc_iter ) = sc_icc;

            % index rotation matrix %
            sc_err_r{ sc_iter } = sc_rr;

            % index translation vector %
            sc_err_t{ sc_iter } = sc_rt;

            % update iteration counter %
            sc_iter = sc_iter + 1;

        end

        % return rotation matrix %
        sc_r = sc_rr;

        % return translation vector %
        sc_t = sc_rt;

    end

