import anthropic
import argparse

client = anthropic.Anthropic()

parser = argparse.ArgumentParser(description='Query Claude from the command line')

# Positional argument
parser.add_argument('prompt', help='Prompt to send to Claude')

parser.add_argument('-s', '--system', type=str, default='', help='System message e.g. "You are an expert programmer", "You are a kind parent talking to a 5-year old child".')

parser.add_argument('-t', '--max-tokens', type=int, default=2000, help='Maximum number of tokens in output.')

parser.add_argument('-T', '--temperature', type=int, default=0, help='Temperature of the model (noise level of response).')

parser.add_argument('-o', '--output', choices=['text', 'full'], default='text', help='Output format (text or full).')

# main function
def main():
    args = parser.parse_args()
    message = client.messages.create(
        model="claude-3-5-sonnet-20240620",
        max_tokens=args.max_tokens,
        temperature=args.temperature,
        system=args.system,
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": args.prompt 
                    }
                ]
            }
        ]
    )
    
    if args.output == 'full':
        print(message)
    else: 
        print(message.content[0].text)

if __name__ == "__main__":
    main()
