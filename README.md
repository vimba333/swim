# swim

## Define the time ranges yourself and document them in the README
The swimmer time ranges are part of the application's business logic.
They are currently defined in the file /Users/iva/vim/s/lib/features/survay/domain/entities/swimmer_level.dart.
In the future, this information must definitely come from the backend.

For now, I selected these ranges myself and rounded them in favor of the better result:

elite,        // 45–70
advanced,     // 71–90
intermediate, // 91–120
beginner,     // 121–240

Why 45–70 instead of 45–69?

I decided that, psychologically, swimmers would find it more motivating to think, “If I swim 100 meters in 90 seconds, I'll become Advanced,” rather than, “I have to swim it in 89 seconds.”

## Include a README with: state management choice and why, brief description of
For state management, I chose BLoC, or more specifically its simpler version, Cubit.

Riverpod would also be a very good choice, but I think that decision is more of a team-wide preference. If everyone on the team likes Riverpod and is comfortable with it, then it makes sense to use it.

From my freelance experience, most developers are familiar with BLoC, even though it can be somewhat verbose and overengineered for smaller projects.

We've also had several cases where projects were initially started with Riverpod but gradually migrated to BLoC over time because new developers joined the team and found BLoC much easier to understand and work with.
