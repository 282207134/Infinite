class Creative {
  const Creative(
    this.id,
    this.name,
    this.role,
    this.avatar, {
    this.verified = true,
  });
  final String id, name, role, avatar;
  final bool verified;
}

class Artwork {
  const Artwork(
    this.id,
    this.title,
    this.image, {
    this.creator = frank,
    this.video = false,
    this.is3d = false,
  });
  final String id, title, image;
  final Creative creator;
  final bool video, is3d;
}

const frank = Creative('frank', 'Frank Marshall', 'Concept Artist', 'frank');
const me = Creative('ruslan', 'Ruslan Sakhbetdinov', 'Concept Artist', 'me');
const brad = Creative('brad', 'Brad Wright', 'Concept Artist', 'brad');
const mary = Creative(
  'mary',
  'Mary Jane Watson',
  'HR',
  'mary',
  verified: false,
);
const miles = Creative('miles', 'Miles Morales', 'Concept Artist', 'miles');
const mandy = Creative('mandy', 'Mandy Jurgens', 'Illustrator', 'mandy');
const sanna = Creative(
  'sanna',
  'Sanna Nielsen',
  'Character Artist',
  'sanna',
  verified: false,
);
const greg = Creative('greg', 'Greg Danton', 'Concept Artist', 'greg');
const creatives = [
  Creative('studio', 'thefagnum', 'Studio', 'studio'),
  greg,
  frank,
  brad,
  mandy,
  miles,
  Creative('james-kong', 'James Kong', 'Animator', 'james_kong'),
  Creative(
    'james-kottak',
    'James Kottak',
    'Comic Art',
    'james_kottak',
    verified: false,
  ),
  Creative('james-koch', 'James Koch', 'Character Artist', 'james_koch'),
];
const abduction = Artwork('abduction', 'Abduction!', 'abduction', video: true);
const spider = Artwork(
  'spiderman',
  'Marvel’s Spider-Man',
  'spiderman',
  video: true,
);
const newWorks = [
  Artwork('ice_hunter', 'The Northern Hunter', 'ice_hunter', video: true),
  Artwork('castle', 'A World Above', 'castle', is3d: true),
  Artwork('wanderer', 'The Wanderer', 'wanderer'),
  Artwork('portal', 'Into the Light', 'portal', is3d: true),
  Artwork('robot', 'Beyond Human', 'robot'),
  Artwork('astronaut', 'Orbital Dreams', 'astronaut'),
];
const profileWorks = [
  Artwork('profile1', 'The Last Guardian', 'profile1', video: true),
  Artwork('profile2', 'A Moment of Silence', 'profile2'),
  Artwork('profile3', 'Stranger Things', 'profile3', is3d: true),
  Artwork('profile4', 'The Outsider', 'profile4'),
];
const gallery = [
  Artwork('more1', 'Neon City', 'more1'),
  Artwork('more2', 'Fire Within', 'more2'),
  Artwork('more3', 'Dark Horizon', 'more3'),
  abduction,
  spider,
  Artwork('dragon', 'KSU', 'dragon'),
  Artwork(
    'livestream',
    'Cinema 4D: Lighting Techniques',
    'livestream',
    video: true,
  ),
];
const allWorks = [...newWorks, abduction, spider, ...profileWorks, ...gallery];
const workDescription =
    "I'm really excited to be part of such a great title. Thank you to Marvel, Insomniac Games and Sony PlayStation for this opportunity to create an art piece for Marvel's Spider-Man. This game looks incredible!";
