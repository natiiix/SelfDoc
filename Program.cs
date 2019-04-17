using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Linq;

namespace SelfDoc
{
    public class Program
    {
        private static Dictionary<string, double> variables = new Dictionary<string, double>();

        private static void Main(string[] args)
        {
            string command = string.Empty;

            while (!string.IsNullOrWhiteSpace(command = Prompt()))
            {
                Match match = null;

                if ((match = Regex.Match(command, @"^let (\w+) be (.+)$")).Success)
                {
                    variables[match.Groups[1].Value] = Evaluate(match.Groups[2].Value);
                }
                else if ((match = Regex.Match(command, @"^print (.+)$")).Success)
                {
                    Console.WriteLine($"{match.Groups[1].Value} = {Evaluate(match.Groups[1].Value)}");
                }
            }
        }

        private static double Evaluate(string str)
        {
            Match match = null;

            if (str.StartsWith('-'))
            {
                return -Evaluate(str.Substring(1));
            }
            else if (variables.ContainsKey(str))
            {
                return variables[str];
            }
            else if (double.TryParse(str, out double value))
            {
                return value;
            }
            else if ((match = Regex.Match(str, @"^(.+?) plus (.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) + Evaluate(match.Groups[2].Value);
            }
            else if ((match = Regex.Match(str, @"^(.+?) minus (.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) - Evaluate(match.Groups[2].Value);
            }
            else if ((match = Regex.Match(str, @"^(.+?) times (.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) * Evaluate(match.Groups[2].Value);
            }
            else if ((match = Regex.Match(str, @"^(.+?) over (.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) / Evaluate(match.Groups[2].Value);
            }
            else if ((match = Regex.Match(str, @"^sum of (.+)$")).Success)
            {
                return SplitArgs(match.Groups[1].Value).Select(x => Evaluate(x)).Sum();
            }
            else if ((match = Regex.Match(str, @"^product of (.+)$")).Success)
            {
                return SplitArgs(match.Groups[1].Value).Select(x => Evaluate(x)).Product();
            }

            throw new ArgumentException("Unable to evaluate: " + str);
        }

        private static string Prompt()
        {
            Console.Write("> ");
            return Console.ReadLine();
        }

        private static string[] SplitArgs(string str) =>
            Regex.Split(str, @"\s*\band\b\s*|\s*,\s*");
    }
}
