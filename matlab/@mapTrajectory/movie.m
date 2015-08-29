function movie_frames = movie(obj, plot_function, room_dim)

f_ref = [];
[~, movie_frames] = obj.(plot_function)(room_dim, f_ref, 'MOVIE_FLAG', 1);

figure;
axis off;
axes('Position',[0 0 1 1])
movie(movie_frames);

end