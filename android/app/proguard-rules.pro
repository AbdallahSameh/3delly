# --- Fix SnakeYAML / JavaBeans issues ---
-dontwarn java.beans.**
-dontwarn javax.**
-dontwarn org.yaml.snakeyaml.**

# Prevent R8 from breaking reflection-based libraries
-keep class org.yaml.snakeyaml.** { *; }
-keep class java.beans.** { *; }