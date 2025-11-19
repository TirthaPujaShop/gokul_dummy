import 'package:flutter/material.dart';

void main() {
  runApp(const TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  const TipCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip Calculator',
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF00D4FF),
      ),
      home: const TipCalculatorPage(),
    );
  }
}

class TipCalculatorPage extends StatefulWidget {
  const TipCalculatorPage({super.key});

  @override
  State<TipCalculatorPage> createState() => _TipCalculatorPageState();
}

class _TipCalculatorPageState extends State<TipCalculatorPage> with SingleTickerProviderStateMixin {
  final TextEditingController billController = TextEditingController();
  int peopleCount = 1;
  double tipPercentage = 15;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    billController.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    _animationController.forward().then((_) => _animationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    double billAmount = double.tryParse(billController.text) ?? 0.0;
    double tipAmount = billAmount * (tipPercentage / 100);
    double totalAmount = billAmount + tipAmount;
    double perPerson = peopleCount > 0 ? totalAmount / peopleCount : totalAmount;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Split Bill",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Calculate & share equally",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
                const SizedBox(height: 35),

                // HERO CARD - Per Person Amount
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00D4FF),
                          Color(0xFF0099FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_rounded,
                              color: Colors.white.withOpacity(0.9),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Per Person",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "₹${perPerson.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1.5,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Split among $peopleCount ${peopleCount == 1 ? 'person' : 'people'}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Bill Amount Input
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4FF).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              color: Color(0xFF00D4FF),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Bill Amount",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: billController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1A1F3A),
                          hintText: "₹0.00",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          prefixIcon: Icon(
                            Icons.currency_rupee,
                            color: Colors.white.withOpacity(0.5),
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {});
                          _triggerAnimation();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tip Percentage
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00D4FF).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.percent_rounded,
                                  color: Color(0xFF00D4FF),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Tip",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4FF).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${tipPercentage.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00D4FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: const Color(0xFF00D4FF),
                          inactiveTrackColor: const Color(0xFF1A1F3A),
                          thumbColor: const Color(0xFF00D4FF),
                          overlayColor: const Color(0xFF00D4FF).withOpacity(0.2),
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12,
                          ),
                        ),
                        child: Slider(
                          value: tipPercentage,
                          min: 0,
                          max: 50,
                          divisions: 50,
                          onChanged: (value) {
                            setState(() => tipPercentage = value);
                            _triggerAnimation();
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "0%",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          Text(
                            "50%",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Number of People
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4FF).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              color: Color(0xFF00D4FF),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Split Between",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCounterButton(
                            icon: Icons.remove,
                            onTap: () {
                              if (peopleCount > 1) {
                                setState(() => peopleCount--);
                                _triggerAnimation();
                              }
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1F3A),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              peopleCount.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          _buildCounterButton(
                            icon: Icons.add,
                            onTap: () {
                              setState(() => peopleCount++);
                              _triggerAnimation();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Summary
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4FF).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.summarize_rounded,
                              color: Color(0xFF00D4FF),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _summaryRow("Bill Amount", "₹${billAmount.toStringAsFixed(2)}"),
                      const SizedBox(height: 12),
                      _summaryRow("Tip Amount", "₹${tipAmount.toStringAsFixed(2)}"),
                      const SizedBox(height: 12),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      const SizedBox(height: 12),
                      _summaryRow(
                        "Total",
                        "₹${totalAmount.toStringAsFixed(2)}",
                        isTotal: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF151B35).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCounterButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00D4FF),
              Color(0xFF0099FF),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 17 : 15,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isTotal ? Colors.white : Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.w700,
            color: isTotal ? const Color(0xFF00D4FF) : Colors.white,
          ),
        ),
      ],
    );
  }
}