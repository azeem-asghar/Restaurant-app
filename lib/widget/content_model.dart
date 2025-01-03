
class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description: "Pick your Food from our menu\n         More than 35 times",
      image: "images/screen1.png",
      title: "Select from our Best Menu"),
  UnboardingContent(
      description:
          "You can pay cash on delivery and\n         Credit card is available",
      image: "images/screen2.png",
      title: "Easy and online payment"),
  UnboardingContent(
      description: "Deliver your food at\n    your Doorsteps",
      image: "images/screen3.png",
      title: "Quick Delivery at your Doorstep")
];
