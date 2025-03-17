/**
 * Typewriter Effect
 * This script creates a typewriter animation effect for the element with ID "tw"
 */

document.addEventListener('DOMContentLoaded', function() {
  // Get the element with ID "tw"
  const twElement = document.getElementById('tw');
  
  if (!twElement) {
    console.error('Element with ID "tw" not found');
    return;
  }
  
  // Store the original text and clear the element
  const originalText = twElement.textContent;
  twElement.textContent = '';
  
  // Set typing speed (milliseconds per character)
  const typingSpeed = 50; // Adjust this value to change typing speed
  
  let charIndex = 0;
  
  // Function to type one character at a time
  function typeWriter() {
    if (charIndex < originalText.length) {
      twElement.textContent += originalText.charAt(charIndex);
      charIndex++;
      setTimeout(typeWriter, typingSpeed);
    }
  }
  
  // Start the typewriter effect
  typeWriter();
});