class HairstyleModel {
  final String id;
  final String name;
  final String imagePath;
  final String gender;
  final bool isTrending;
  final bool isPopular;

  HairstyleModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.gender,
    this.isTrending = false,
    this.isPopular = false,
  });
}

final List<HairstyleModel> sampleHairstyles = [
  HairstyleModel(
    id: '1',
    name: 'Crew Cut',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/crew_cut.png',
    isPopular: true,
  ),
  HairstyleModel(
    id: '2',
    name: 'Buzz Cut',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/buzz_cut.png',
  ),
  HairstyleModel(
    id: '3',
    name: 'Sports Buzz',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/sports_buzz.png',
  ),
  HairstyleModel(
    id: '4',
    name: 'Clean Short',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/clean_short.png',
    isPopular: true,
  ),
  HairstyleModel(
    id: '5',
    name: 'Slicked Back',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/slicked_back.png',
  ),
  HairstyleModel(
    id: '6',
    name: 'Pompadour',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/pompadour.png',
    isPopular: true,
  ),
  HairstyleModel(
    id: '7',
    name: 'Comb Over',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/comb_over.png',
  ),
  HairstyleModel(
    id: '8',
    name: 'Side Slick',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/side_slick.png',
  ),
  HairstyleModel(
    id: '9',
    name: 'Retro Greaser',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/retro_greaser.png',
  ),
  HairstyleModel(
    id: '10',
    name: 'Undercut',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/undercut.png',
    isTrending: true,
  ),
  HairstyleModel(
    id: '11',
    name: 'Textured Hair',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/textured_hair.png',
    isTrending: true,
  ),
  HairstyleModel(
    id: '12',
    name: 'Messy Hair',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/messy_hair.png',
  ),
  HairstyleModel(
    id: '13',
    name: 'Korean Middle Part',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/korean_middle_part.png',
    isTrending: true,
  ),
  HairstyleModel(
    id: '14',
    name: 'Mohawk',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/mohawk.png',
  ),
  HairstyleModel(
    id: '15',
    name: 'Curly Hair',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/curly_hair.png',
  ),
  HairstyleModel(
    id: '16',
    name: 'Stylish Perm',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/stylish_perm.png',
    isTrending: true,
  ),
  HairstyleModel(
    id: '17',
    name: 'Tin Foil Perm',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/tin_foil_perm.png',
  ),
  HairstyleModel(
    id: '18',
    name: 'Bowl Cut',
    gender: 'male',
    imagePath: 'assets/hairstyles/male/bowl_cut.png',
  ),

  HairstyleModel(
    id: '19',
    name: 'Long Layers',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/long_layers.png',
    isPopular: true,
  ),
  HairstyleModel(
    id: '20',
    name: 'Curtain Bangs',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/curtain_bangs.png',
    isTrending: true,
  ),
  HairstyleModel(
    id: '21',
    name: 'Blunt Bob',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/blunt_bob.png',
  ),
  HairstyleModel(
    id: '22',
    name: 'Wavy Lob',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/wavy_lob.png',
    isPopular: true,
  ),
  HairstyleModel(
    id: '23',
    name: 'Pixie Cut',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/pixie_cut.png',
  ),
  HairstyleModel(
    id: '24',
    name: 'Wolf Cut',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/wolf_cut.png',
    isTrending: true,
  ),
  HairstyleModel(
    id: '25',
    name: 'Soft Curls',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/soft_curls.png',
    isPopular: true,
  ),
  HairstyleModel(
    id: '26',
    name: 'Sleek Straight',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/sleek_straight.png',
  ),
  HairstyleModel(
    id: '27',
    name: 'Side Swept Waves',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/side_swept_waves.png',
  ),
  HairstyleModel(
    id: '28',
    name: 'Butterfly Cut',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/butterfly_cut.png',
    isTrending: true,
  ),
  HairstyleModel(
    id: '29',
    name: 'Korean Air Bangs',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/corean_air_bangs.png',
    isTrending: true,
  ),
  HairstyleModel(
    id: '30',
    name: 'High Ponytail',
    gender: 'female',
    imagePath: 'assets/hairstyles/female/high_ponytail.png',
  ),
];
