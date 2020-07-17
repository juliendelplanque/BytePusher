Extension { #name : #String }

{ #category : #'*BytePusher-Assembler' }
String >> encodeAsASCII [
	"Encode the String as a ByteArray using ASCII format.
	"
	^ ByteArray streamContents: [ :stream |
		self do: [ :character |
			stream nextPut: character asciiValue ] ]
]

{ #category : #'*BytePusher-Assembler' }
String >> encodeAsASCIINullTerminatedString [
	"Encode the String as a ByteArray using ASCII format.
	 Adds the Character null at the end of ByteArray so the string is null-terminated.
	"
	^ self encodeAsASCII , (ByteArray with: Character null asciiValue)
]
