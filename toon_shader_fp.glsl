// Illumination based on the traditional three-term model

#version 130

// Attributes passed from the vertex shader
in vec3 position_interp;
in vec3 normal_interp;
in vec3 light_pos;

// Material attributes (constants)
vec4 ambient_color = vec4(0.0, 1.0, 0.0, 1.0);
vec4 diffuse_color = vec4(1.0, 0.0, 0.0, 1.0);
vec4 specular_color = vec4(0.8, 0.5, 0.9, 1.0);
float phong_exponent = 64.0;
float Ia = 0.2; // Ambient light amount

// Material attributes (constants) for 2nd light


void main() 
{
    vec3 N, // Interpolated normal for fragment
         L, // Light-source direction
         V, // View direction
		 R, // Reflection vector
		 R2, 
		 L2,
         H; // Half-way vector


    // Compute Lambertian term Id
    N = normalize(normal_interp);

    L = (light_pos - position_interp);
    L = normalize(L);

	float Id;// = max(dot(N, L), 0.0);
	if(dot(N, L) > 0.9){
		Id = max(1.0, 0.0);
		//gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	}
	else if (dot(N, L) <= 0.9 && dot(N, L) > 0.7) {
		Id = max(0.7, 0.0);
		//gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
	}
	else if(dot(N, L) <= 0.7 && dot(N, L) >= 0.4){
		Id = max(0.5, 0.0);
		//gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
	}
	else if (dot(N, L) < 0.4 && dot(N, L) >= 0.1) {
		Id = max(0.3, 0.0);
		//gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
	}
	else if(dot(N, L) < 0.1){
		Id = max(0.0, 0.0);
		//gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);
	}
    
    // Compute specular term Is for Blinn-Phong shading
    // V = (eye_position - position_interp);
    V = - position_interp; // Eye position is (0, 0, 0) in view coordinates
    V = normalize(V);

	//Reflection Vector
	R = -L + 2.0*Id*N;


    //H = 0.5*(V + L); // Halfway vector
    H = (V + L); // Halfway vector (will be normalized anyway)
    H = normalize(H);

    //float spec_angle_cos = max(dot(N, H), 0.0); //For blinn-phong
	float spec_angle_cos = max(dot(V, R), 0.0); //For phong
    float spec_angle_cos2 = max(dot(V, R2), 0.0); //For phong
    

	float Is = pow(spec_angle_cos, phong_exponent);
	if (Is > 0.5) {
		Is = max(1.0, 0.0);
		//gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	}
	else {
		Is = max(0.0, 0.0);
	}

	
	
    // Assign illumination to the fragment
	
	if (dot(N, V) > 0.4) {
		gl_FragColor = Ia * ambient_color + Id * diffuse_color + Is * specular_color;
	}
	else {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	}

			  
    // For debug, we can display the different values
	
    //gl_FragColor = ambient_color;
    //gl_FragColor = diffuse_color;
    //gl_FragColor = specular_color;
    //gl_FragColor = color_interp;
    //gl_FragColor = vec4(N.xyz, 1.0);
    //gl_FragColor = vec4(L.xyz, 1.0);
    //gl_FragColor = vec4(V.xyz, 1.0);
}
