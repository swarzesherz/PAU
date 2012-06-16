#!/usr/bin/perl -w
use Tk;
use strict;

my $pwd;
chomp($pwd = `pwd`);

my $id_vendedor;
#chomp($id_vendedor = `cat id`);
$id_vendedor=1;
my $id_venta=`psql burgerking -A -t -c "select last_value from venta_venta_id_seq"`+1;



my $mw = MainWindow->new( -title=>'PAU Pct');
my $image1 = $mw->Photo(-file => "./imagenes/boton1.gif");
my $image2 = $mw->Photo(-file => "./imagenes/boton2.gif");
my $image3 = $mw->Photo(-file => "./imagenes/boton3.gif");
my $image4 = $mw->Photo(-file => "./imagenes/boton4.gif");
my $image5 = $mw->Photo(-file => "./imagenes/boton5.gif");
my $image6 = $mw->Photo(-file => "./imagenes/boton6.gif");
my $image7 = $mw->Photo(-file => "./imagenes/boton7.gif");
my $image8 = $mw->Photo(-file => "./imagenes/boton8.gif");
my $image9 = $mw->Photo(-file => "./imagenes/boton9.gif");
my $image10 = $mw->Photo(-file => "./imagenes/boton10.gif");


my $left_frame = $mw->Frame()->pack(-side => 'left');
my $right_frame = $mw->Frame()->pack(-side => 'right');
my $r_right_frame = $right_frame->Frame()->pack(-side => 'right');
my $r_left_frame = $right_frame->Frame()->pack(-side => 'left');




my $paste_text = $r_right_frame->Text(-width=>50, -height=>60, -background => "white", 
                                    -foreground => "black")->pack(-side => 'top');
my $clear_text = $r_right_frame->Button(-text => "Cancelar pedido", 
                                  -command => \&clear_entry)->pack(-side => 'left');
my $pedido = $r_right_frame->Button(-text => "Realizar pedido", 
                                  -command => \&realizar)->pack(-side => 'right');



$left_frame->Button(-text => '', -command => sub 	{ 
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Combo N1 WHOPPER X $cantidad");
									registro(int($id_venta),1,int($cantidad)); 
								}							
							},
           						 -image => $image1)->pack;

$left_frame->Button(-text => '', -command => sub {
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Combo N2 WHOPPER DOBLE X $cantidad"); 
									registro(int($id_venta),2,int($cantidad));
								}
							},
            						-image => $image2)->pack;
$left_frame->Button(-text => '', -command => sub {
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Combo N3 X-TREME X $cantidad"); 
									registro(int($id_venta),3,int($cantidad));
								}
							},
            						-image => $image3)->pack;
$left_frame->Button(-text => '', -command => sub {
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Combo N4 WHOPPER Furioso X $cantidad");  
									registro(int($id_venta),4,int($cantidad));
								}
							},
            -image => $image4)->pack;
$left_frame->Button(-text => '', -command => sub { 
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Combo N5 Cheessy WHOPPER X $cantidad"); 
									registro(int($id_venta),5,int($cantidad));
								}
							},
            -image => $image5)->pack;
$r_left_frame->Button(-text => '', -command => sub {
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Combo N6 WHOPPER jr X $cantidad");  
									registro(int($id_venta),6,int($cantidad));
								}
							},
            -image => $image6)->pack;
$r_left_frame->Button(-text => '', -command => sub { 
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Combo N7 MEGA ANGUS XT X $cantidad");  
									registro(int($id_venta),7,int($cantidad));
								}
							},
            -image => $image7)->pack;
$r_left_frame->Button(-text => '', -command => sub {
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Extra N8 REFRESCO X $cantidad");  
									registro(int($id_venta),8,int($cantidad));
								}
							},
            -image => $image8)->pack;
$r_left_frame->Button(-text => '', -command => sub { 
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Extra N9 PAPAS X $cantidad");  
									registro(int($id_venta),9,int($cantidad));
								}
							},
            -image => $image9)->pack;
$r_left_frame->Button(-text => '', -command => sub { 
								my $cantidad = escala();
								if (defined $cantidad && $cantidad ne ""){
									$paste_text->insert("end", "Extra N10 PAY DE MANZANA X $cantidad");  
									registro(int($id_venta),10,int($cantidad));
								}
							},
            -image => $image10)->pack;







sub clear_entry {
`> ./DB_BurgerKing/pedidos.SQL`;
 $paste_text->delete('0.0', 'end');

} 

sub realizar {
	`psql burgerking -A -t -c "insert into venta values (default,$id_vendedor,default,default)"`;
	`psql burgerking < ./DB_BurgerKing/pedidos.SQL`;
	 $id_venta++;
	 clear_entry();
	

  	
} 

sub escala {
  `zenity --scale --text="Selecciona la cantidad de productos" --value=1 --min-value=1 --max-value=10`;
}

sub registro {

my ($venta_id,$producto_id,$cantidad)=@_;
my $precio_venta=`psql burgerking -A -t -c "select precio from producto where producto_id=$producto_id"`;
`echo "insert into producto_venta values(default,$venta_id,$producto_id,$cantidad,($precio_venta*$cantidad));" >> ./DB_BurgerKing/pedidos.SQL`;
}


MainLoop;
`> ./DB_BurgerKing/pedidos.SQL`;
exit 0;

