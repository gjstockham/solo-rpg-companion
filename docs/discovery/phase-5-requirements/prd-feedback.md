# PRD Feedback

## Feedback on PRD Draft v1.0

2.2 Note taking apps like Obsidian do have some options for rules additions with dice rollers, rule updates etc., but they are no very user-friendly

US-017 I think the logs should _already_ be stored in markdown in the file store

US-022 We won't have multiple systems, but we should make everything modular in anticipation

FR-004/FR-005 The current chat session should save after every message which means no need for auto-save

FR-030 Fate accelerated as executable code - why does this need to be C#?  Could we create an AI agent that encodes this knowledge, and maintains plain markdown / json representations of character sheet etc.?

FR-020 I wonder if this could be hybrid, with SQLite for searching and management, but player-known knowledge stored in a file system.  Almost like a "world wiki"?

FR-021 Session log should be on disk.  Player should be able to browse and store however they want.  This might be a mis-explanation on my part but I want the File-system to be similar to what I already have in obsidian, but for the AI / App we will probably need db/vector store etc.

FR-022 Current conversation log is a great example of something that can _definitely_ be in the database

FR-023 Can we have a technical note to spike or explore a graph RAG.  This might be good for connections.

FR-024 Maybe character sheet could be markdown and not in db?


