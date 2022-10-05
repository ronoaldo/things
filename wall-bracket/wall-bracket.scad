// Tamanho do espaço para caber o objeto
esp = 50;
// Largura do suporte
larg = 8;
// Se o suporte deve ser arredondado nas bordas
rounded = true;
// Altura do suporte
altsup = 35;

$fn = 60;

module suporte() {
    // Braço da frente
    color("red")
    translate([0, 0, larg])
        cube([larg, larg, altsup]);
    // Área para parafusar
    color("yellow")
    translate([0, esp+larg, -(altsup)/2])
        cube([larg*2, 3, altsup+larg*2]);
    color("brown")
    // Haste
    cube([larg, esp + larg, larg]);
    // Reforço
    translate([larg/2, esp+larg, 0])
        rotate([90, 0, 0])
        cylinder(h=esp+larg, r1=larg/2, r2=larg/2);
}

if (rounded) {
    minkowski() {
        suporte();
        sphere(1);
    }
} else {
    suporte();
}