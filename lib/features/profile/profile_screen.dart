import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showave/features/auth/auth_provider.dart';
import 'package:showave/features/profile/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.navigate_before, size: 25),
          ),
        ),
      ),
      body: userAsync.when(
        data: (user) => Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          spacing: 10,
          mainAxisSize: .max,
          children: [
            const SizedBox(height: 20),
            Container(
              alignment: .center,
              decoration: const BoxDecoration(
                shape: .circle,
                color: Color.fromARGB(188, 209, 182, 218),
              ),
              padding: const EdgeInsets.all(25),
              child: Text(
                user.name.characters.first,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: .bold,
                  color: const Color.fromARGB(149, 33, 0, 104),
                ),
              ),
            ),
            Text(
              user.name,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: .bold),
            ),
            Text(
              user.email,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color.fromARGB(150, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () => context.go("/order_history"),
                child: Row(
                  mainAxisAlignment: .start,
                  children: [
                    const Icon(Icons.receipt_sharp),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        "Order History",
                        style: TextStyle(fontWeight: .bold),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.subdirectory_arrow_right_rounded),
                  ],
                ),
              ),
            ),
            const Divider(height: 10, endIndent: 0, indent: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () async =>
                    await ref.read(authProvider.notifier).logout(),
                child: Row(
                  mainAxisAlignment: .start,
                  children: [
                    const Icon(
                      Icons.logout,
                      color: Color.fromARGB(246, 206, 49, 49),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: .bold,
                          color: Color.fromARGB(246, 206, 49, 49),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              mainAxisSize: .max,
              children: [
                Icon(
                  Icons.view_carousel_sharp,
                  size: 50,
                  color: const Color.fromARGB(149, 234, 0, 0),
                ),
                const Text("Something went wrong"),
                Text(error.toString(), overflow: .ellipsis, maxLines: 3),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(profileProvider);
                  },
                  child: Text("Retry"),
                ),
              ],
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
