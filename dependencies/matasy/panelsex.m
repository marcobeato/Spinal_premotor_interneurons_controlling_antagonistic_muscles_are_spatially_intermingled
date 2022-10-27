% Panel example

x = linspace(-pi, pi, 400);
P = panels([2, 3], [12, 8]);

for i = 1:6
  ax = P.setPanel(i);
  plot(x, sin(x*i));
  xlabel('x');
  ylabel('y');
end

P.addLabels();
P.addPanels();

