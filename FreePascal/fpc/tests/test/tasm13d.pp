{ %CPU=i8086,i386,x86_64 }
{ %fail }

{ Tests the 'Cannot override ES segment' error message }

{$asmmode intel}

begin
  asm
{$if defined(cpui8086)}
    stos byte ptr ds:[di]
{$elseif defined(cpui386)}
    stos byte ptr ds:[edi]
{$elseif defined(cpux86_64)}
    stos byte ptr fs:[rdi]
{$endif}
  end;
end.
