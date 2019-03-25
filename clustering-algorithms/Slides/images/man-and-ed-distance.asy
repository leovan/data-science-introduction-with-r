pen dps = linewidth(0.7) + fontsize(0);
defaultpen(dps);
draw((0, 100)--(0, 0), linewidth(2));
draw((0, 0)--(200, 0), linewidth(2));
draw((200, 0)--(0, 100), linewidth(2) + linetype("2 4"));
pen dotstyle = black;
dot((200, 0), dotstyle);
dot((0, 100), dotstyle);
label("$(2, 0)$", (220, 0));
label("$(0, 1)$", (0, 110));
label("Euclidean Distance", (160, 60));
label("Manhattan Distance", (0, -10));