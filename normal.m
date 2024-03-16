normspec([7,17],12,2.5)
hold on
sz1=50
sz2=100
c1=[0.4660 0.6740 0.1880];
c2=[0.8500 0.3250 0.0980];
mkr1="o"
mkr2="pentagram"
scatter(12,0,sz1,c1,'filled',mkr1)
scatter(14.5,0,sz2,c2,'filled',mkr2)

ta1 = annotation('textarrow', [0.4 0.5], [0.2 0.11]);
ta1.String = 'predicted value '            
ta1.Color = [1 1 1]  

ta2 = annotation('textarrow', [0.6 0.5], [0.2 0.11]);
ta2.String = 'true value '            
ta2.Color = [1 1 1]
