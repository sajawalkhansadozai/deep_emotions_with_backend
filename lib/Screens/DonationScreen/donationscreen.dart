import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/Button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DonationScreen extends StatefulWidget {
  final String videoId; // Accept videoId as a parameter

  const DonationScreen({super.key, required this.videoId});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int? selectedIndex;
  final List<int> amounts = [150, 100, 50, 30]; // Removed duplicates
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveDonationToFirestore() async {
    final String amountText = _amountController.text.trim();

    if (amountText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    try {
      int amount = int.parse(amountText);
      String videoId = widget.videoId;

      // 🟢 صرف Donations Collection میں Data Store کرو
      await FirebaseFirestore.instance.collection('Donations').add({
        'videoId': videoId,
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation saved successfully!')),
      );

      _amountController.clear();
      setState(() => selectedIndex = null);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save donation: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // Adjust to your app's theme
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildTopBar(screenWidth, screenHeight, context),
              SizedBox(height: screenHeight * 0.04),
              buildImageSection(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.02),
              buildDonationText(),
              SizedBox(height: screenHeight * 0.03),
              buildAmountInput(screenHeight),
              SizedBox(height: screenHeight * 0.03),
              buildAmountGrid(),
              SizedBox(height: screenHeight * 0.03),
              GestureDetector(
                onTap: _saveDonationToFirestore,
                child: ReusableButton(
                  buttonText: 'I\'m happy to help',
                  route: '/home', // 🔹 Add this line
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopBar(
    double screenWidth,
    double screenHeight,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.04,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => GoRouter.of(context).go('/home'),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white, // Adjust to your app's theme
              size: screenHeight * 0.04,
            ),
          ),
          Text(
            'Donation',
            style: TextStyle(
              color: Colors.white, // Adjust to your app's theme
              fontSize: screenHeight * 0.025,
            ),
          ),
          SizedBox(width: screenHeight * 0.04),
        ],
      ),
    );
  }

  Widget buildImageSection(double screenWidth, double screenHeight) {
    return Center(
      child: Container(
        height: screenHeight * 0.3,
        width: screenWidth * 0.8,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/LastImage.png',
            ), // Replace with your asset
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildDonationText() {
    return const Text(
      'How much would you like to donate?',
      style: TextStyle(color: Colors.white, fontSize: 18),
      textAlign: TextAlign.center,
    );
  }

  Widget buildAmountInput(double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: screenHeight * 0.06,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number, // Restrict input to numbers
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter Amount',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAmountGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20, // Reduced from 110 for better layout
          mainAxisSpacing: 10,
          mainAxisExtent: 58,
        ),
        itemCount: amounts.length,
        itemBuilder: (context, index) {
          return AmountButton(
            amount: amounts[index],
            isSelected: selectedIndex == index,
            onTap: () {
              setState(() {
                selectedIndex = index;
                _amountController.text = amounts[index].toString();
              });
            },
          );
        },
      ),
    );
  }
}

class AmountButton extends StatelessWidget {
  final int amount;
  final bool isSelected;
  final VoidCallback onTap;

  const AmountButton({
    required this.amount,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 58,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.white,
            width: 0.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '\$$amount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
