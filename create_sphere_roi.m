function create_sphere_roi(x, y, z, radius, filename, roi_path, mni_template_path)
    % Set the center coordinates and radius of the sphere
    center = [x, y, z]; % Replace x, y, z with the desired coordinates
    % radius = 5; % Replace with the desired radius

    if nargin < 5
        filename = 'sphere.nii';
    end

    if nargin < 6
        roi_path = '/Users/bschott/ownCloud/FADE/analyses_BS/DCM/ROIs/'; % directory with ROIs and MNI template
    end

    % Load MNI template
    if nargin < 7
        mni_template_filename = 'mni152.nii';
        mni_template_path = fullfile(roi_path, mni_template_filename);
    end
    mni_template = spm_vol(mni_template_path);
    [mni_X, mni_Y, mni_Z] = ndgrid(1:mni_template.dim(1), 1:mni_template.dim(2), 1:mni_template.dim(3));

    % Convert center coordinates from MNI space to voxel indices
    vx_center = round(mni_template.mat \ [center, 1]');

    % Create a grid of coordinates in MNI space
    [X, Y, Z] = ndgrid(mni_template.mat(1, 1) * (1:mni_template.dim(1)), ...
                       mni_template.mat(2, 2) * (1:mni_template.dim(2)), ...
                       mni_template.mat(3, 3) * (1:mni_template.dim(3)));

    % Compute the distance of each voxel from the center
    distances = sqrt((X - X(vx_center(1), vx_center(2), vx_center(3))).^2 + ...
                     (Y - Y(vx_center(1), vx_center(2), vx_center(3))).^2 + ...
                     (Z - Z(vx_center(1), vx_center(2), vx_center(3))).^2);

    % Create a binary mask indicating which voxels are within the sphere
    sphere_mask = distances <= radius;

    % Create a new Nifti image based on the MNI template
    nii = mni_template;
    nii.fname = fullfile(roi_path, filename); % Replace with the desired path for the sphere Nifti file

    % Set the data type and write the sphere mask to the Nifti image
    nii.dt = [spm_type('uint8'), 0]; % Set the data type of the Nifti image
    nii.private.dat.dtype = 'UINT8'; % Set the data type for the image data
    nii.private.dat.fname = nii.fname;
    spm_write_vol(nii, sphere_mask);

    disp(['Sphere Nifti file saved at: ', fullfile(roi_path, filename)]);
end
