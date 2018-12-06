
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

    % @brief Pose estimation
    %
    % This function estimates the rotation and translation between two cameras
    % based on the provided features projections (unitary directions vector).
    %
    % An iterations starts by computing a first estimation of the rotation and
    % translation that occurs between the two point sets defined by the two
    % camera features. In the first iteration, the features defines 3D models
    % that are collapsed on the unit sphere (the projection of the features
    % having discarded the depth information). On the basis of this first pose
    % estimation, the algorithm corrects the position of the features by
    % computing their best intersections. The next iteration then starts with
    % two points sets that should be a bit close to the real scene, allowing to
    % get a better estimation of rotation and translation.
    %
    % At each iteration, the error on features position (the distance that
    % separates their position according to the first and second cameras) is
    % computed and used as a stop condition. The iteration stops as this error
    % stops moving of more than the provided tolerance value.
    %
    % A features filtering process is also made at each iteration to be sure
    % that no outlier appears in the sets of features. Such outliers can lead
    % to instabilities that conduct the pose estimation to fail.
    %
    % @param  sc_da      First camera features directions unitary vector
    % @param  sc_db      Second camera features directions unitary vector
    % @param  sc_tol     Iteration stop condition (tolerance)
    %
    % @return sc_r       Estimated rotation matrix
    % @return sc_t       Estimated translation vector
    % @return sc_ra      First camera last iteration features radii
    % @return sc_rb      Second camera last iteration features radii
    % @return sc_da      First camera last iteration features directions
    % @return sc_db      Second camera last iteration features directions
    % @return sc_err_rad Maximum features error array (for all iterations)
    % @return sc_err_r   Estimated rotation matrix (for all iterations)
    % @return sc_err_r   Estimated translation vector (for all iterations)

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

