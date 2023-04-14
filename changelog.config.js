module.exports = {
  disableEmoji: false,
  format: "{emoji}{type}: {subject}",
  list: [
    "fix",
    "feat",
    "refactor",
    "test",
    "style",
    "chore",
  ],
  maxMessageLength: 80,
  minMessageLength: 3,
  questions: ["type", "subject"],
  scopes: [],
  types: {
    chore: {
      description: "Build process or auxiliary tool or documentation changes",
      emoji: '🤖',
      value: "chore",
    },
    feat: {
      description: "A new feature",
      emoji: '🎸',
      value: "feat",
    },
    fix: {
      description: "A bug fix",
      emoji: '🐛',
      value: "fix",
    },
    refactor: {
      description: "A code change that neither fixes a bug or adds a feature",
      emoji: '💡',
      value: "refactor",
    },
    style: {
      description: 'Markup, white-space, formatting, missing semi-colons...',
      emoji: '💄',
      value: 'style',
    },
    test: {
      description: 'Adding missing tests',
      emoji: '💍',
      value: 'test',
    },
  },
};
