Extension { #name : #String }

{ #category : #'*BytePusher-Assembler' }
String >> encodeAsASCIINullTerminatedString [
	"Encode the String as a ByteArray using ASCII format.
	 Adds the Character null at the end of ByteArray so the string is null-terminated.
	"
	^ ByteArray streamContents: [ :stream |
		self do: [ :character |
			stream nextPut: character asciiValue ].
		stream nextPut: Character null asciiValue ]
]
