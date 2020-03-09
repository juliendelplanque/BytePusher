Extension { #name : #BPAssembler }

{ #category : #'*BytePusher-Assembler-HighLevel' }
BPAssembler >> if: a equals: b then: thenBuilder else: elseBuilder [
	| uuidString labelIfEqual labelContinue |
	uuidString := UUIDGenerator next asString.
	labelIfEqual := ('ifEqual-' , uuidString) asSymbol.
	labelContinue := ('continue-' , uuidString) asSymbol.
	self
		cmp: a with: b;
		jumpIfEqual: labelIfEqual.
	
	elseBuilder value: self.
	self
		jump: labelContinue;
		label: labelIfEqual.
	
	thenBuilder value: self.
	
	self
		label: labelContinue;
		nop "Ensure we can label even if we are at the end of the program."
]

{ #category : #'*BytePusher-Assembler-HighLevel' }
BPAssembler >> while: a equals: b do: doBuilder [
	| uuidString labelWhileNotEqual labelContinue |
	uuidString := UUIDGenerator next asString.
	labelWhileNotEqual := ('whileNotEqual-' , uuidString) asSymbol.
	labelContinue := ('continue-' , uuidString) asSymbol.
	self
		label: labelWhileNotEqual;
		cmp: a with: b;
		jumpIfNotEqual: labelContinue.
	
	doBuilder value: self.
	self jump: labelWhileNotEqual.
	
	self
		label: labelContinue;
		nop "Ensure we can label even if we are at the end of the program."
]

{ #category : #'*BytePusher-Assembler-HighLevel' }
BPAssembler >> while: a isNotEquals: b do: doBuilder [
	| uuidString labelWhileNotEqual labelContinue |
	uuidString := UUIDGenerator next asString.
	labelWhileNotEqual := ('whileNotEqual-' , uuidString) asSymbol.
	labelContinue := ('continue-' , uuidString) asSymbol.
	self
		label: labelWhileNotEqual;
		cmp: a with: b;
		jumpIfEqual: labelContinue.
	
	doBuilder value: self.
	self jump: labelWhileNotEqual.
	
	self
		label: labelContinue;
		nop "Ensure we can label even if we are at the end of the program."
]
