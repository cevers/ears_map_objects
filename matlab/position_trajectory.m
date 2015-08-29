function state = position_trajectory( num_samples, num_states, time_vec, F, Q, velocity, pos )

% Target dynamics - straight line
state = zeros(num_states, num_samples);
state(:,1) = pos;
for time_ind = 2 : num_samples,
    % True target state:
    dt = time_vec(time_ind) - time_vec(time_ind-1);
    u_t = velocity*dt;
    state(:,time_ind) = F * state(:,time_ind-1) + u_t + Q*randn(num_states,1);
end;

end